CREATE TABLE IF NOT EXISTS instance_questions (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    open BOOLEAN DEFAULT TRUE,
    number INTEGER,
    order_by INTEGER DEFAULT floor(random() * 1000000),
    points DOUBLE PRECISION DEFAULT 0,
    points_in_grading DOUBLE PRECISION DEFAULT 0,
    score_perc DOUBLE PRECISION DEFAULT 0,
    score_perc_in_grading DOUBLE PRECISION DEFAULT 0,
    current_value DOUBLE PRECISION,
    number_attempts INTEGER DEFAULT 0,
    points_list DOUBLE PRECISION[],
    status enum_instance_question_status DEFAULT 'unanswered'::enum_instance_question_status,
    assessment_instance_id BIGINT NOT NULL REFERENCES assessment_instances ON DELETE CASCADE ON UPDATE CASCADE,
    assessment_question_id BIGINT NOT NULL REFERENCES assessment_questions ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (assessment_question_id, assessment_instance_id)
);

ALTER TABLE instance_questions ADD COLUMN IF NOT EXISTS status enum_instance_question_status DEFAULT 'unanswered';

--UPDATE instance_questions AS iq
--SET
--    status = exam_question_status(iq)::enum_instance_question_status;
