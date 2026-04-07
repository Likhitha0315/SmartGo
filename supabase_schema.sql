-- ================================================================
-- SmartGo - Smart Transportation App
-- Supabase PostgreSQL Schema
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ─── 1. USERS TABLE ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.smartgo_users (
  id                  UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name           TEXT NOT NULL DEFAULT '',
  phone               TEXT NOT NULL UNIQUE,
  service_type        TEXT NOT NULL DEFAULT 'passenger'
                        CHECK (service_type IN ('passenger', 'driver')),
  driving_experience  INTEGER,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── 2. VEHICLES TABLE ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.vehicles (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  driver_id       UUID,
  driver_name     TEXT NOT NULL,
  driver_phone    TEXT NOT NULL,
  vehicle_type    TEXT NOT NULL
                    CHECK (vehicle_type IN ('bus', 'car', 'bike', 'shared_auto')),
  vehicle_number  TEXT NOT NULL DEFAULT '',
  fare_per_km     NUMERIC(6,2) NOT NULL DEFAULT 5.0,
  is_available    BOOLEAN NOT NULL DEFAULT true,
  from_location   TEXT NOT NULL DEFAULT '',
  to_location     TEXT NOT NULL DEFAULT '',
  distance_km     NUMERIC(8,2),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── 3. BOOKINGS TABLE ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.bookings (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         UUID REFERENCES public.smartgo_users(id) ON DELETE SET NULL,
  vehicle_id      UUID,
  driver_name     TEXT NOT NULL DEFAULT '',
  driver_phone    TEXT NOT NULL DEFAULT '',
  vehicle_type    TEXT NOT NULL DEFAULT '',
  from_location   TEXT NOT NULL DEFAULT '',
  to_location     TEXT NOT NULL DEFAULT '',
  fare            NUMERIC(10,2) NOT NULL DEFAULT 0,
  payment_method  TEXT NOT NULL DEFAULT 'upi',
  status          TEXT NOT NULL DEFAULT 'confirmed'
                    CHECK (status IN ('pending','confirmed','completed','cancelled')),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── 4. FEEDBACK TABLE ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.feedback (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID,
  message     TEXT NOT NULL,
  rating      INTEGER NOT NULL DEFAULT 5
                CHECK (rating BETWEEN 1 AND 5),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── 5. SOS ALERTS TABLE ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.sos_alerts (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID,
  location    TEXT NOT NULL DEFAULT '',
  message     TEXT NOT NULL DEFAULT 'Emergency!',
  status      TEXT NOT NULL DEFAULT 'active'
                CHECK (status IN ('active', 'resolved')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── INDEXES ─────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_vehicles_type      ON public.vehicles(vehicle_type);
CREATE INDEX IF NOT EXISTS idx_vehicles_available ON public.vehicles(is_available);
CREATE INDEX IF NOT EXISTS idx_bookings_user      ON public.bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status    ON public.bookings(status);
CREATE INDEX IF NOT EXISTS idx_sos_status         ON public.sos_alerts(status);

-- ─── ROW LEVEL SECURITY ──────────────────────────────────────────
ALTER TABLE public.smartgo_users  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vehicles       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feedback       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sos_alerts     ENABLE ROW LEVEL SECURITY;

-- smartgo_users policies
CREATE POLICY "users_select_own"
  ON public.smartgo_users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "users_insert_own"
  ON public.smartgo_users FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "users_update_own"
  ON public.smartgo_users FOR UPDATE
  USING (auth.uid() = id);

-- vehicles: anyone authenticated can read
CREATE POLICY "vehicles_read_all"
  ON public.vehicles FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "vehicles_insert_driver"
  ON public.vehicles FOR INSERT
  WITH CHECK (auth.uid() = driver_id);

-- bookings policies
CREATE POLICY "bookings_select_own"
  ON public.bookings FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "bookings_insert_own"
  ON public.bookings FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- feedback: any authenticated user can insert
CREATE POLICY "feedback_insert"
  ON public.feedback FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- sos_alerts: any authenticated user can insert
CREATE POLICY "sos_insert"
  ON public.sos_alerts FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- ─── REALTIME ─────────────────────────────────────────────────────
ALTER PUBLICATION supabase_realtime ADD TABLE public.vehicles;
ALTER PUBLICATION supabase_realtime ADD TABLE public.bookings;

-- ─── SEED DATA: VEHICLES ─────────────────────────────────────────
-- These match the document screenshots exactly:
-- Bus ₹25, Car ₹50, Bike ₹20, Shared Auto ₹15
INSERT INTO public.vehicles
  (driver_name, driver_phone, vehicle_type, vehicle_number, fare_per_km,
   is_available, from_location, to_location, distance_km)
VALUES
  ('Ramu Naidu',    '9876543210', 'bus',         'AP16AB1234', 3.0,  true,  'Nambur',     'Guntur',     15),
  ('Suresh Kumar',  '9876543211', 'car',         'AP16CD5678', 8.0,  true,  'Nambur',     'Guntur',     15),
  ('Venkat Rao',    '9876543212', 'bike',        'AP16EF9012', 4.0,  true,  'Nambur',     'Pedakakani', 5),
  ('Krishna Reddy', '9876543213', 'shared_auto', 'AP16GH3456', 3.0,  true,  'Nambur',     'Guntur',     15),
  ('Prasad Babu',   '9876543214', 'bus',         'AP16IJ7890', 3.0,  false, 'Pedakakani', 'Guntur',     10),
  ('Hari Babu',     '9876543215', 'car',         'AP16KL2345', 8.0,  true,  'Guntur',     'Nambur',     15),
  ('Srinu Yadav',   '9876543216', 'shared_auto', 'AP16MN6789', 3.0,  true,  'Nambur',     'Pedakakani', 5),
  ('Mohan Rao',     '9876543217', 'bike',        'AP16OP0123', 4.0,  true,  'Guntur',     'Pedakakani', 10);

-- ─── VERIFY ───────────────────────────────────────────────────────
-- Run to verify setup:
-- SELECT COUNT(*) FROM vehicles;      -- Should show 8
-- SELECT vehicle_type, COUNT(*) FROM vehicles GROUP BY vehicle_type;
