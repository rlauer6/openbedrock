AC_DEFUN([AX_DISTCHECK_HACK], [

    AC_MSG_CHECKING([[whether to enable distcheck hacking]])

    AC_ARG_ENABLE([distcheck-hack],
        [[  --enable-distcheck-hack      configure distcheck_hack, exposes $DISTCHECK_HACK_ENABLED]],

        dnl AC_ARG_ENABLE: option if given
        [
            case "${enableval}" in
                yes)  DISTCHECK_HACK_ENABLED=true  ;;
                no)   DISTCHECK_HACK_ENABLED=false ;;
                *)
                    AC_MSG_ERROR([bad value ("$enableval") for '--enable-distcheck-hack' option])
                    ;;
            esac
        ],

        dnl AC_ARG_ENABLE: option if not given
        [
            DISTCHECK_HACK_ENABLED=false
        ]
    )

    if ${DISTCHECK_HACK_ENABLED}; then
        AC_MSG_RESULT([yes])
    else
        AC_MSG_RESULT([no])
    fi

    dnl register a conditional for use in Makefile.am files
    AM_CONDITIONAL([DISTCHECK_HACK_ENABLED], [${DISTCHECK_HACK_ENABLED}])
])

