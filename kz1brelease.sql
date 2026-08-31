-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function kz1brelease(
	artistid integer
)
returns table(
	artist_id integer,
	release_id integer,
	releasecount_artist bigint,
	releasecount bigint
)
as $$
begin
return query
	select
		rax.artist_id,
		rax.release_id,
		rax.releasecount_artist,
		rax.releasecount
	from
		(
		select
			ra.artist_id,
			ra.release_id,
			ra.releasecount_artist,
			rc.releasecount
		from
			(
			select
				n.artist_id,
				n.release_id,
				count(n.release_id) as releasecount_artist
			from
				release_artist n
			where
				n.release_id in
					(
					select
						s.release_id
					from
						release_artist s
					where
						s.artist_id = artistid
					)
				and n.extra = 0
			group by
				n.artist_id,
				n.release_id
			) ra

		left join

			(
			select
				x.release_id,
				count(x.release_id) as releasecount
			from
				release_artist x
			where
				x.release_id in
					(
					select
						v.release_id
					from
						release_artist v
					where
						v.artist_id = artistid
					)
				and x.extra = 0
			group by
				x.release_id
			) rc
		on
			ra.release_id = rc.release_id
		) rax
	where
		rax.artist_id = artistid
	;
end;
$$ language plpgsql;
