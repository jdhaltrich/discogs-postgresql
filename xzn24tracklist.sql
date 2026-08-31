-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function xzn24tracklist(
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
	release_collaboration integer,
	tracknumber text,
	sequence integer,
	title text,
	duration text,
	parent text
)
as $$
begin
return query
	select
		xf.artist_id,
		xf.artist_name,
		xf.master_id,
		xf.mastercount_artist,
		xf.mastercount,
		xf.master_collaboration,
		xf.master_year,
		xf.master_title,
		xf.master_data_quality,
		xf.release_id,
		xf.release_date,
		xf.release_title,
		xf.release_country,
		xf.release_data_quality,
		xf.releasecount_artist,
		xf.releasecount,
		xf.release_collaboration,
		rt.tracknumber,
		rt.sequence,
		rt.title,
		rt.duration,
		rt.parent
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
			n.master_data_quality,
			n.release_id,
			n.release_date,
			n.release_title,
			n.release_country,
			n.release_data_quality,
			n.releasecount_artist,
			n.releasecount,
			n.release_collaboration
		from
			xzn13release(
				artistid
			) n
		) xf

	left join

		(
		select
			s.release_id,
			s.position as tracknumber,
			s.sequence,
			s.title,
			s.duration,
			s.parent
		from
			release_track s
		) rt
	on
		xf.release_id = rt.release_id
	;
end;
$$ language plpgsql;
