-module(atomvm_gleam_ffi).

% -export([start_with_result/0, set_pin_mode_with_result/2, digital_write_with_result/2]).
-export([
    % GPIO
    start_with_result/0,set_pin_mode_with_result/2, digital_write_with_result/2,
    wait_for_ap_with_result/0,
    % OTP
    application_stopped/0, convert_system_message/2,
    static_supervisor_start_link/1
]).


% GPIO --------------------------------------------------------------------

start_with_result() ->
    case gpio:start() of
        ok -> {ok, nil};
        error -> {error, nil};
        {error, _} = E -> E
    end.

set_pin_mode_with_result(_Pin, _Direction) ->
    case gpio:set_pin_mode(_Pin, _Direction) of
        ok -> {ok, _Pin};
        error -> {error, nil};
        {error, _} = E -> E
    end.

digital_write_with_result(_Pin, _Level) ->
    case gpio:digital_write(_Pin, _Level) of
        ok -> {ok, _Pin};
        error -> {error, nil};
        {error, _} = E -> E
    end.


% NETWORK ------------------------------------------------------------------


wait_for_ap_with_result() ->
    case network:wait_for_ap() of
        ok -> {ok, nil};
        error -> {error, nil};
        {error, _} = E -> E
    end.


% HTTP SERVER --------------------------------------------------------------



% OTP ----------------------------------------------------------------------

convert_system_message({From, Ref}, Request) when is_pid(From) ->
    Reply = fun(Msg) ->
        erlang:send(From, {Ref, Msg}),
        nil
    end,
    System = fun(Callback) ->
        {system, {Request, Callback}}
    end,
    case Request of
        get_status -> System(fun(Status) -> Reply(process_status(Status)) end);
        get_state -> System(fun(State) -> Reply({ok, State}) end);
        suspend -> System(fun() -> Reply(ok) end);
        resume -> System(fun() -> Reply(ok) end);
        Other -> {unexpected, Other}
    end.

process_status({status_info, Module, Parent, Mode, DebugState, State}) ->
    Data = [
        get(), Mode, Parent, DebugState,
        [{header, "Status for Gleam process " ++ pid_to_list(self())},
         {data, [{'Status', Mode}, {'Parent', Parent}, {'State', State}]}]
    ],
    {status, self(), {module, Module}, Data}.

application_stopped() ->
    ok.

static_supervisor_start_link(Arg) ->
    case supervisor:start_link(atomvm_gleam@otp@static_supervisor, Arg) of
        {ok, P} -> {ok, P};
        {error, E} -> {ok, {init_crashed, E}}
    end.