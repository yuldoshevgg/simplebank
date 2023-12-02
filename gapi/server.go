package gapi

import (
	"fmt"

	db "github.com/yuldoshevgg/simplebank/db/sqlc"
	"github.com/yuldoshevgg/simplebank/pb"
	"github.com/yuldoshevgg/simplebank/token"
	"github.com/yuldoshevgg/simplebank/util"
	"github.com/yuldoshevgg/simplebank/worker"
)

type Server struct {
	store      db.Store
	tokenMaker token.Maker
	config     util.Config
	pb.UnimplementedSimpleBankServer
	taskDistributor worker.TaskDistributor
}

func NewServer(config util.Config, store db.Store, taskDistributor worker.TaskDistributor) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("Cannot create token maker: %v", err)
	}

	server := &Server{
		config:          config,
		store:           store,
		tokenMaker:      tokenMaker,
		taskDistributor: taskDistributor,
	}

	return server, nil
}
