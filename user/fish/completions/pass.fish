complete -c $PROG -f -n '__fish_pass_needs_command' -s c -l clip -d 'Generate an OTP code'
complete --no-files pass -a '(__fish_pass_print_entries)' -n '__fish_pass_uses_command otp'
