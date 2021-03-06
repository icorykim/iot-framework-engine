%% @author Georgios Koutsoumpakis
%%   [www.csproj13.student.it.uu.se]
%% @version 1.0
%% @copyright [Copyright information]

%% @doc Callbacks for the engine application.

-module(engine_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).

-include_lib("amqp_client.hrl").


% %% @spec start(_Type, _StartArgs) -> ServerRet
% %% @doc application start callback for engine.
% start(_Type, _StartArgs) ->
% 	erlastic_search_app:start(),
%     engine_sup:start_link().

% %% @spec stop(_State) -> ServerRet
% %% @doc application stop callback for engine.
% stop(_State) ->
%     ok.

%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for engine.
start(_Type, _StartArgs) ->
        erlastic_search_app:start(),
        singleton:start(),
        {ok,Connection} = amqp_connection:start(#amqp_params_network{host = "localhost"}),
        singleton:set(Connection),
        engine_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for engine.
stop(_State) ->
        {ok, Connection } = singleton:get(),
        ok = amqp_connection:close(Connection),
        ok.
