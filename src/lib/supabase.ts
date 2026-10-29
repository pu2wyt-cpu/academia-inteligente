import { createClient } from '@supabase/supabase-js'

// Public browser configuration. Environment variables override these defaults.
// Never place a service_role key or sb_secret key in this file.
const url = (import.meta.env.VITE_SUPABASE_URL as string | undefined)
  || 'https://hrjdnbdirtnhvnyhmznc.supabase.co'
const publishableKey = (import.meta.env.VITE_SUPABASE_ANON_KEY as string | undefined)
  || 'sb_publishable_p_2SNbJHsbMXqPUfHCnRQg_z_baezPU'

export const isSupabaseConfigured = Boolean(url && publishableKey)

export const supabase = isSupabaseConfigured
  ? createClient(url, publishableKey, {
      auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true },
    })
  : null
