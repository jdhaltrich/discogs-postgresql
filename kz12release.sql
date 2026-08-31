-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function kz12release(
	artistid integer
)
returns table(
	artist_id integer,
	master_id integer,
	release_id integer,
	release_date text,
	release_title text,
	release_country text,
	release_data_quality text,
	releasecount_artist bigint,
	releasecount bigint
)
as $$
begin
return query
	select
		rc.artist_id,
		rx.master_id,
		rx.release_id,
		rx.release_date,
		rx.release_title,
		rx.release_country,
		rx.release_data_quality,
		rc.releasecount_artist,
		rc.releasecount
	from
		(
		select
			n.release_id,
			n.master_id,
			n.release_date,
			n.release_title,
			n.release_country,
			n.release_data_quality
		from
			kz1arelease(
				artistid
			) n
		) rx

	left join

		(
		select
			x.release_id,
			x.artist_id,
			x.releasecount_artist,
			x.releasecount
		from
			kz1brelease(
				artistid
			) x
		) rc
	on
		rx.release_id = rc.release_id
	;
end;
$$ language plpgsql;
