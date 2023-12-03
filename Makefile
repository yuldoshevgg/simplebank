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

new_migration:
	migrate create -ext sql -dir db/migration -seq $(name)

sqlc: 
	sqlc generate

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/yuldoshevgg/simplebank/db/sqlc Store
	mockgen -package mockwk -destination worker/mock/distributor.go github.com/yuldoshevgg/simplebank/worker TaskDistributor
 
db_docs:
	dbdocs build doc/db.dbml

db_schema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

test:
	go test -v -cover -short ./...

evans:
	evans --host localhost --port 9091 -r repl

redis:
	docker run --name redis -p 6379:6379 -d redis

proto:
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
    --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
		--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
		--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simplebank \
    proto/*.proto
		statik -src=./doc/swagger -dest=./doc

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 new_migration sqlc db_docs db_schema test server mock evans redis proto