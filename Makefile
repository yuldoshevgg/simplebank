postgres:
	docker run --name postgresql --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -d postgres

createdb:
	docker exec -it postgresql createdb --username=root --owner=root simplebank

dropdb:
	docker exec -it postgresql dropdb simplebank

migrateup: 
	migrate -path db/migration -database "postgresql://root:FkSK3aAcz90lMM8ITc9Q@simplebank.c09i5st5zpvo.us-east-1.rds.amazonaws.com:5432/simple_bank" -verbose up
	
migrateup1: 
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simplebank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simplebank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simplebank?sslmode=disable" -verbose down 1

sqlc: 
	sqlc generate

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/yuldoshevgg/simplebank/db/sqlc Store

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test server mock