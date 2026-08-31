-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function zzn13release(
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
		n.artist_id,
		n.artist_name,
		n.master_id,
		n.mastercount_artist,
		n.mastercount,
		n.master_collaboration,
		n.master_year,
		n.master_title,
		n.master_data_quality,
		n.release_id,
		n.release_date,
		n.release_title,
		n.release_country,
		n.release_data_quality
	from
		zz13release(
			artistid
		) n

	union all

	select
		x.artist_id,
		x.artist_name,
		x.master_id,
		x.mastercount_artist,
		x.mastercount,
		x.master_collaboration,
		x.master_year,
		x.master_title,
		x.master_data_quality,
		x.release_id,
		x.release_date,
		x.release_title,
		x.release_country,
		x.release_data_quality
	from
		zn13release(
			artistid
		) x
	;
end;
$$ language plpgsql;
