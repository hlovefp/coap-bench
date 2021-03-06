%%%-------------------------------------------------------------------
%% @doc coap_bench top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(coap_bench_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    ok = coap_bench_cli:init_cli(),
    ok = coap_bench_profiles:init(),
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{strategy => one_for_one,
                 intensity => 5,
                 period => 2},
    ChildSpecs = [
        #{id => sim_manager,
          start => {sim_manager, start_link, []},
          restart => permanent,
          shutdown => brutal_kill,
          type => supervisor},
        #{id => sim_trash,
          start => {sim_trash, start_link, []},
          restart => permanent,
          shutdown => brutal_kill,
          type => supervisor}
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
