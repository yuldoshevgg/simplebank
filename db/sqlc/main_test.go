package db

import (
	"context"
	"log"
	"os"
	"testing"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/yuldoshevgg/simplebank/util"
)

var testStore Store

func TestMain(m *testing.M) {
	config, err := util.LoadConfig("../../")
	if err != nil {
		log.Fatal("cannot load config: ", err)
	}

	connPool, err := pgxpool.New(context.Background(), config.DBSource)
	if err != nil {
		log.Fatal("Cannot connect to db: ", err)
	}

	testStore = NewStore(connPool)
	os.Exit(m.Run())
}
