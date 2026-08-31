-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function xz11master(
	artistid integer
)
returns table(
	artist_id integer,
	artist_name text,
	master_id integer,
	mastercount_artist bigint,
	mastercount bigint,
	master_collaboration integer
)
as $$
begin
return query
	select
		xa.artist_id,
		xa.artist_name,
		xm.master_id,
		xm.mastercount_artist,
		xm.mastercount,
		case
			when xm.mastercount_artist < xm.mastercount then 1
			when xm.mastercount_artist = xm.mastercount then 0
			when xm.mastercount_artist > xm.mastercount then 2
			else 3
		end as master_collaboration
	from
		(
		select
			n.artist_id,
			n.artist_name
		from
			xz11artist(
				artistid
			) n
		) xa

	left join

		(
		select
			s.artist_id,
			s.master_id,
			s.mastercount_artist,
			s.mastercount
		from
			kz11master(
				artistid
			) s
		order by
			s.master_id
		) xm
	on
		xa.artist_id = xm.artist_id
	where
		xm.master_id is not null
	;
end;
$$ language plpgsql;
