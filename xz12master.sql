-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function xz12master(
	artistid integer
)
returns table(
	artist_id integer,
	artist_name text,
	master_id integer,
	mastercount_artist bigint,
	mastercount bigint,
	master_collaboration integer,
	master_year integer,
	master_title text,
	master_data_quality text
)
as $$
begin
return query
	select
		xa.artist_id,
		xa.artist_name,
		xa.master_id,
		xa.mastercount_artist,
		xa.mastercount,
		xa.master_collaboration,
		xm.master_year,
		xm.master_title,
		xm.master_data_quality
	from
		(
		select
			n.artist_id,
			n.artist_name,
			n.master_id,
			n.mastercount_artist,
			n.mastercount,
			n.master_collaboration
		from
			xz11master(
				artistid
			) n
		) xa

	left join

		(
		select
			s.id as master_id,
			s.year as master_year,
			s.title as master_title,
			s.data_quality as master_data_quality
		from
			master s
		) xm
	on
		xa.master_id = xm.master_id
	;
end;
$$ language plpgsql;
