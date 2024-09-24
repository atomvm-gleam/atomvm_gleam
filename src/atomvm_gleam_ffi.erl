-module(atomvm_gleam_ffi).

% -export([start_with_result/0, set_pin_mode_with_result/2, digital_write_with_result/2]).
-export([set_pin_mode_with_result/2, digital_write_with_result/2]).


% GPIO --------------------------------------------------------------------

% start_with_result() ->
%     case gpio:start() of
%         ok -> {ok, nil};
%         error -> {error, nil};
%         {error, _} = E -> E
%     end.

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

