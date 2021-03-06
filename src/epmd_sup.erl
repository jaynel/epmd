%%
%% %CopyrightBegin%
%% 
%% Copyright Peer Stritzinger GmbH 2013-2015. All Rights Reserved.
%% 
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%% 
%% %CopyrightEnd%
%%
%%

-module(epmd_sup).
-behaviour(supervisor).

%% API
-export([start_link/1, get_childspecs/0]).

%% supervisor callbacks
-export([init/1]).

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init(_Args) ->
    error_logger:info_msg("epmd - service started~n"),
    %% Hint:
    %% Child_spec = {Name, {M, F, A},
    %%               Restart, Shutdown_time, Type, Modules_used}
    {ok, {{one_for_one, 3, 60}, get_childspecs()}}.

get_childspecs() ->
    [{epmd_reg, 
      {epmd_reg, start_link, []},
      permanent,
      5000,
      worker,
      [epmd_reg]},
     {epmd_listen_sup, 
      {epmd_listen_sup, start_link, []},
      permanent,
      5000,
      supervisor,
      [epmd_listen_sup]}
    ].
