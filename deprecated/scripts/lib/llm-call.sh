#!/usr/bin/env bash
# scripts/lib/llm-call.sh — LLM call abstraction
#
# Three backends: llm (Simon Willison's CLI), claude (Anthropic CLI), stub (testing).
# Ported from shellclaw lib/llm.sh, adapted for assertion-graph.
#
# Environment:
#   SB_LLM_BACKEND  — "llm", "claude", or "stub" (default: "llm")
#   SB_MODEL        — Model identifier (optional)
#
# Usage:
#   source scripts/lib/llm-call.sh
#   llm_call "What is 2+2?"
#   llm_call "Summarize this" --system "You are a helpful assistant"
#   llm_call "Follow up" --continue --conversation-id "abc123"
#   echo "$context" | llm_call - --system "prompt"   # stdin mode
#   SB_LLM_BACKEND=stub llm_call "test message"

_SB_STUB_COUNTER_FILE="${TMPDIR:-/tmp}/sb_stub_counter_$$"

# llm_call <message|-> [--system <prompt>] [--model <model>] [--backend <llm|claude|stub>]
#           [--continue] [--conversation-id <id>]
llm_call() {
    local message=""
    local system_prompt=""
    local model=""
    local backend=""
    local continue_flag=false
    local conversation_id=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --system)
                system_prompt="${2:-}"
                [[ -z "$system_prompt" ]] && { echo "llm_call: --system requires a value" >&2; return 1; }
                shift 2 ;;
            --model)
                model="${2:-}"
                [[ -z "$model" ]] && { echo "llm_call: --model requires a value" >&2; return 1; }
                shift 2 ;;
            --backend)
                backend="${2:-}"
                [[ -z "$backend" ]] && { echo "llm_call: --backend requires a value" >&2; return 1; }
                shift 2 ;;
            --continue)
                continue_flag=true
                shift ;;
            --conversation-id)
                conversation_id="${2:-}"
                [[ -z "$conversation_id" ]] && { echo "llm_call: --conversation-id requires a value" >&2; return 1; }
                shift 2 ;;
            -)
                if [[ -z "$message" ]]; then
                    message="-"
                else
                    echo "llm_call: unexpected argument: $1" >&2
                    return 1
                fi
                shift ;;
            -*)
                echo "llm_call: unknown flag: $1" >&2
                return 1 ;;
            *)
                if [[ -z "$message" ]]; then
                    message="$1"
                else
                    echo "llm_call: unexpected argument: $1" >&2
                    return 1
                fi
                shift ;;
        esac
    done

    # Stdin mode: "-" means read message from stdin
    if [[ "$message" == "-" ]]; then
        message=$(cat)
    fi

    if [[ -z "$message" ]]; then
        echo "llm_call: message required" >&2
        return 1
    fi

    backend="${backend:-${SB_LLM_BACKEND:-llm}}"

    case "$backend" in
        stub)   _sb_llm_stub "$message" ;;
        llm)    _sb_llm_real "$message" "$system_prompt" "$model" "$continue_flag" "$conversation_id" ;;
        claude) _sb_llm_claude "$message" "$system_prompt" "$model" ;;
        *)      echo "llm_call: unknown backend: $backend" >&2; return 1 ;;
    esac
}

_sb_llm_stub() {
    local count=0
    if [[ -f "$_SB_STUB_COUNTER_FILE" ]]; then
        count=$(cat "$_SB_STUB_COUNTER_FILE")
    fi
    count=$(( count + 1 ))
    echo "$count" > "$_SB_STUB_COUNTER_FILE"
    echo "stub response ${count}"
}

llm_stub_reset() {
    rm -f "$_SB_STUB_COUNTER_FILE"
}

_sb_llm_real() {
    local message="$1" system_prompt="$2" model="$3" continue_flag="$4" conversation_id="$5"

    if ! command -v llm &>/dev/null; then
        echo "llm_call: llm CLI not found (install: pip install llm)" >&2
        return 1
    fi

    local cmd=(llm)
    [[ -n "$system_prompt" ]] && cmd+=(-s "$system_prompt")

    local effective_model="${model:-${SB_MODEL:-}}"
    [[ -n "$effective_model" ]] && cmd+=(-m "$effective_model")

    [[ "$continue_flag" == "true" ]] && cmd+=(-c)
    [[ -n "$conversation_id" ]] && cmd+=(--cid "$conversation_id")

    printf '%s' "$message" | "${cmd[@]}"
}

_sb_llm_claude() {
    local message="$1" system_prompt="$2" model="$3"

    if ! command -v claude &>/dev/null; then
        echo "llm_call: claude CLI not found" >&2
        return 1
    fi

    local cmd=(claude -p --no-session-persistence)
    [[ -n "$system_prompt" ]] && cmd+=(--system-prompt "$system_prompt")

    local effective_model="${model:-${SB_MODEL:-}}"
    [[ -n "$effective_model" ]] && cmd+=(--model "$effective_model")

    printf '%s' "$message" | "${cmd[@]}"
}
