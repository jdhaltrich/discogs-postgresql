-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function kn1arelease(
	artistid integer
)
returns table(
	release_id integer,
	release_title text,
	release_date text,
	release_country text,
	release_data_quality text,
	master_id integer
)
as $$
begin
return query
	select
		ru.release_id,
		ru.release_title,
		ru.release_date,
		ru.release_country,
		ru.release_data_quality,
		ru.master_id
	from
		(
		select
			n.id as release_id,
			n.title as release_title,
			n.released as release_date,
			n.country as release_country,
			n.data_quality as release_data_quality,
			n.master_id
		from
			release n
		) ru

	inner join

		(
		select
			t.release_id
		from
			release_no_master t
		where
			t.artist_id = artistid
		group by
			t.release_id
		) zp
	on
		ru.release_id = zp.release_id
	;
end;
$$ language plpgsql;
