-- migrate:up
-- With this we can customize the id of the migration in Electric
CALL electric.migration_version('20240713123905');

CREATE TABLE expense (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "amount"  DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL,
    "updatedAt" TIMESTAMPTZ NOT NULL,
    PRIMARY KEY ("id")
);

ALTER TABLE expense ENABLE ELECTRIC;

-- migrate:down
