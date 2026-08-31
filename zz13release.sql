-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function zz13release(
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
	master_data_quality text,
	release_id integer,
	release_date text,
	release_title text,
	release_country text,
	release_data_quality text
)
as $$
begin
return query
	select
		xm.artist_id,
		xm.artist_name,
		xm.master_id,
		xm.mastercount_artist,
		xm.mastercount,
		xm.master_collaboration,
		xm.master_year,
		xm.master_title,
		xm.master_data_quality,
		xr.release_id,
		xr.release_date,
		xr.release_title,
		xr.release_country,
		xr.release_data_quality
	from
		(
		select
			n.artist_id,
			n.artist_name,
			n.master_id,
			n.mastercount_artist,
			n.mastercount,
			n.master_collaboration,
			n.master_year,
			n.master_title,
			n.master_data_quality
		from
			xz12master(
				artistid
			) n
		) xm

	left join

		(
		select
			x.master_id,
			x.release_id,
			x.release_date,
			x.release_title,
			x.release_country,
			x.release_data_quality
		from
			kz1arelease(
				artistid
			) x
		order by
			x.master_id
		) xr
	on
		xm.master_id = xr.master_id
	;
end;
$$ language plpgsql;
