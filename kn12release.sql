-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function kn12release(
	artistid integer
)
returns table(
	artist_id integer,
	master_id integer,
	release_id integer,
	release_title text,
	release_date text,
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
		ft.artist_id,
		tf.master_id,
		tf.release_id,
		tf.release_title,
		tf.release_date,
		tf.release_country,
		tf.release_data_quality,
		ft.releasecount_artist,
		ft.releasecount,
		case
			when ft.releasecount_artist < ft.releasecount then 1
			when ft.releasecount_artist = ft.releasecount then 0
			when ft.releasecount_artist > ft.releasecount then 2
			else 3
		end as release_collaboration
	from
		(
		select
			n.release_id,
			n.release_title,
			n.release_date,
			n.release_country,
			n.release_data_quality,
			n.master_id
		from
			kn1arelease(
				artistid
			) n
		) tf

	left join

		(
		select
			x.artist_id,
			x.release_id,
			x.releasecount_artist,
			x.releasecount
		from
			kn1brelease(
				artistid
			) x
		) ft
	on
		tf.release_id = ft.release_id
	;
end;
$$ language plpgsql;
