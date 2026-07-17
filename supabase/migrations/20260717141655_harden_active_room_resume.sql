alter function public.get_my_active_game_room() security invoker;

comment on function public.get_my_active_game_room() is
  'RLS-protected lookup for the authenticated player''s newest recoverable CO-OP or Race room.';
