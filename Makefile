DB_URL=postgresql://root:root@localhost:5432/simplebank?sslmode=disable

postgres:
	docker run --name postgresql --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -d postgres

createdb:
	docker exec -it postgresql createdb --username=root --owner=root simplebank

dropdb:
	docker exec -it postgresql dropdb simplebank

migrateup: 
	migrate -path db/migration -database "$(DB_URL)" -verbose up
	
migrateup1: 
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

sqlc: 
	sqlc generate

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/yuldoshevgg/simplebank/db/sqlc Store

db_docs:
	dbdocs build doc/db.dbml

db_schema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc db_docs db_schema test server mock