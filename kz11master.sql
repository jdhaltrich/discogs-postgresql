-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function kz11master(
	artistid integer
)
returns table(
	artist_id integer,
	master_id integer,
	mastercount_artist bigint,
	mastercount bigint
)
as $$
begin
return query
	select
		xrd.artist_id,
		xrd.master_id,
		xrd.mastercount_artist,
		xrd.mastercount
	from
		(
		select
			xa.artist_id,
			xa.master_id,
			xa.mastercount_artist,
			xm.mastercount
		from
			(
			select
				n.artist_id,
				n.master_id,
				count(n.master_id) as mastercount_artist
			from
				master_artist n
			where
				n.master_id in
					(
					select
						x.master_id
					from
						master_artist x
					where
						x.artist_id = artistid
					)
			group by
				n.artist_id,
				n.master_id
			) xa

		left join

			(
			select
				s.master_id,
				count(s.master_id) as mastercount
			from
				master_artist s
			where
				s.master_id in
					(
					select
						v.master_id
					from
						master_artist v
					where
						v.artist_id = artistid
					)
			group by
				s.master_id
			) xm
		on
			xa.master_id = xm.master_id
		) xrd
	where
		xrd.artist_id = artistid
	;
end;
$$ language plpgsql;
