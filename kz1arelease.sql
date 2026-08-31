-- SPDX-License-Identifier: GNU General Public License v2.0 only
-- Copyright (c) 2026 Juan Diluca
-- See the LICENSE file in the repository root for details.

create or replace function kz1arelease(
	artistid integer
)
returns table(
	master_id integer,
	release_id integer,
	release_title text,
	release_date text,
	release_country text,
	release_data_quality text
)
as $$
begin
return query
	select
		n.master_id,
		n.id as release_id,
		n.title as release_title,
		n.released as release_date,
		n.country as release_country,
		n.data_quality as release_data_quality
	from
		release n
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
	;
end;
$$ language plpgsql;
