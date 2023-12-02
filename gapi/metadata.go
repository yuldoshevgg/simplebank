package gapi

import (
	"context"

	"google.golang.org/grpc/metadata"
)

const (
	grpcGatewayUserAgentHandlerHeader = "grpcgateway-user-agent"
	xForwordedForHeader               = "x-forwarded-for"
)

type Metadata struct {
	UserAgent string
	ClientIp  string
}

func (server *Server) extractMetadata(ctx context.Context) *Metadata {
	mtdt := &Metadata{}

	if md, ok := metadata.FromIncomingContext(ctx); ok {
		if userAgents := md.Get(grpcGatewayUserAgentHandlerHeader); len(userAgents) > 0 {
			mtdt.UserAgent = userAgents[0]
		}

		if clientIps := md.Get(xForwordedForHeader); len(clientIps) > 0 {
			mtdt.ClientIp = clientIps[0]
		}
	}

	return mtdt
}
