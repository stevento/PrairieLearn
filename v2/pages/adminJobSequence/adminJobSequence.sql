-- BLOCK select_job_sequence
WITH member_jobs AS (
    SELECT
        j.*,
        format_date_full_compact(js.start_date) AS start_date_formatted,
        format_date_full_compact(js.finish_date) AS finish_date_formatted,
        u.uid AS user_uid,
        authn_u.uid AS authn_user_uid
    FROM
        jobs AS j
        LEFT JOIN users AS u ON (u.id = js.user_id)
        LEFT JOIN users AS authn_u ON (authn_u.id = js.authn_user_id)
    WHERE
        j.job_sequence_id = $job_sequence_id
        AND j.course_id = $course_id
),
aggregated_member_jobs AS (
    SELECT
        count(*) AS job_count,
        array_agg(jsonb_agg(*)) AS jobs
    FROM
        member_jobs
)
SELECT
    js.*,
    format_date_full_compact(js.start_date) AS start_date_formatted,
    format_date_full_compact(js.finish_date) AS finish_date_formatted,
    u.uid AS user_uid,
    authn_u.uid AS authn_user_uid,
    aggregated_member_jobs.*
FROM
    job_sequences AS js
    LEFT JOIN users AS u ON (u.id = js.user_id)
    LEFT JOIN users AS authn_u ON (authn_u.id = js.authn_user_id),
    aggregated_member_jobs
WHERE
    js.id = $job_sequence_id
    AND js.course_id = $course_id;
