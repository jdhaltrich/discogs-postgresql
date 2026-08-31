-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function xzn24format(
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
	label_id integer,
	label_name text,
	catno text,
	release_format text,
	release_descriptions text,
	text_string text
)
as $$
begin
return query
	select
		xrl.artist_id,
		xrl.artist_name,
		xrl.master_id,
		xrl.mastercount_artist,
		xrl.mastercount,
		xrl.master_collaboration,
		xrl.master_year,
		xrl.master_title,
		xrl.master_data_quality,
		xrl.release_id,
		xrl.release_date,
		xrl.release_title,
		xrl.release_country,
		xrl.release_data_quality,
		xrl.releasecount_artist,
		xrl.releasecount,
		xrl.release_collaboration,
		xrl.label_id,
		xrl.label_name,
		xrl.catno,
		xrf.release_format,
		xrf.release_descriptions,
		xrf.text_string
	from
		(
		select
			xa.artist_id,
			xa.artist_name,
			xa.master_id,
			xa.mastercount_artist,
			xa.mastercount,
			xa.master_collaboration,
			xa.master_year,
			xa.master_title,
			xa.master_data_quality,
			xa.release_id,
			xa.release_date,
			xa.release_title,
			xa.release_country,
			xa.release_data_quality,
			xa.releasecount_artist,
			xa.releasecount,
			xa.release_collaboration,
			xl.label_id,
			xl.label_name,
			xl.catno
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
			) xa

		left join

			(
			select
				s.release_id,
				s.label_id,
				s.label_name,
				s.catno
			from
				release_label s
			) xl
		on
			xa.release_id = xl.release_id
		) xrl

	left join

		(
		select
			f.release_id,
			f.name as release_format,
			f.descriptions as release_descriptions,
			f.text_string
		from
			release_format f
		) xrf
	on
		xrl.release_id = xrf.release_id
	;
end;
$$ language plpgsql;
