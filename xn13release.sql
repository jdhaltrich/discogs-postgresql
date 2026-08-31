-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function xn13release(
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
	release_data_quality text,
	releasecount_artist bigint,
	releasecount bigint,
	release_collaboration integer
)
as $$
begin
return query
	select
		xra.artist_id,
		xra.artist_name,
		vxn.master_id,
		xra.mastercount_artist,
		xra.mastercount,
		xra.master_collaboration,
		xra.master_year,
		xra.master_title,
		xra.master_data_quality,
		vxn.release_id,
		vxn.release_date,
		vxn.release_title,
		vxn.release_country,
		vxn.release_data_quality,
		vxn.releasecount_artist,
		vxn.releasecount,
		vxn.release_collaboration
	from
		(
		select
			n.artist_id,
			n.artist_name,
			0::bigint as mastercount_artist,
			0::bigint as mastercount,
			0 as master_collaboration,
			0 as master_year,
			'no_master' as master_title,
			'no_master' as master_data_quality
		from
			xz11artist(
				artistid
			) n
		) xra

	left join

		(
		select
			x.artist_id,
			x.master_id,
			x.release_id,
			x.release_title,
			x.release_date,
			x.release_country,
			x.release_data_quality,
			x.releasecount_artist,
			x.releasecount,
			x.release_collaboration
		from
			kn12release(
				artistid
			) x
		) vxn
	on
		xra.artist_id = vxn.artist_id
	where
		vxn.release_id is not null
	;
end;
$$ language plpgsql;
