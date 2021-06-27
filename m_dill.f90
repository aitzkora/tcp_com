module m_dill

  use iso_c_binding, only : c_char, c_int, c_int64_t, c_size_t , &
                            c_null_char, c_carriage_return, c_new_line
  implicit none

  private
  public :: ipaddr, ipaddr_local, IPADDR_IPV4, ipaddr_str, ipaddr_port, from_c, & 
            TCP_SUFFIX, tcp_listen, tcp_accept, tcp_close, & 
            suffix_attach, suffix_detach, msend

  type, bind(c) :: ipaddr
    character(c_char) :: address(32)
  end type ipaddr

  integer(c_int), parameter :: IPADDR_IPV4 = 1
  character(len=*), parameter :: TCP_SUFFIX = c_carriage_return // c_new_line // c_null_char

  interface

    function ipaddr_local(addr, name, port, mode) bind(c, name = "dill_ipaddr_local")
      import :: c_char, c_int, ipaddr
      type(ipaddr), intent(out) :: addr
      character(c_char), intent(in) :: name(*)
      integer(c_int), value, intent(in) :: port
      integer(c_int), value, intent(in) :: mode
    end function ipaddr_local


    subroutine ipaddr_str(addr, ipstr) bind(c, name = "dill_ipaddr_str")
      import :: c_char, c_int, ipaddr
      type(ipaddr), intent(in) :: addr
      character(c_char), intent(out) :: ipstr(*)
    end subroutine ipaddr_str
    
    function ipaddr_port(addr) bind(c, name = "dill_ipaddr_port")
      import :: c_char, c_int, ipaddr
      type(ipaddr), intent(out) :: addr
      integer(c_int) :: ipaddr_port
    end function ipaddr_port

    integer(c_int) function tcp_listen(addr, backlog) bind(c, name = "dill_tcp_listen")
      import :: c_int, ipaddr
      type(ipaddr), intent(in) :: addr
      integer(c_int), value, intent(in) :: backlog
    end function tcp_listen

    integer(c_int) function tcp_accept(socket, addr, deadline) bind(c, name = "dill_tcp_accept")
      import :: c_int, c_int64_t, ipaddr
      integer(c_int), value, intent(in) :: socket
      type(ipaddr), intent(out) :: addr
      integer(c_int64_t), intent(in) :: deadline
    end function tcp_accept
    
    integer(c_int) function tcp_close(socket, deadline) bind(c, name = "dill_tcp_close")
      import :: c_int, c_int64_t, ipaddr
      integer(c_int), value, intent(in) :: socket
      integer(c_int64_t), intent(in) :: deadline
    end function tcp_close

    integer(c_int) function suffix_attach(socket, suffix, suffix_len) bind(c, name = "dill_suffix_attach")
      import :: c_int, c_size_t, c_char
      integer(c_int), value, intent(in) :: socket
      character(c_char), intent(in) :: suffix(*)
      integer(c_size_t), value, intent(in) ::suffix_len 
    end function suffix_attach
    
    integer(c_int) function suffix_detach(socket, deadline) bind(c, name = "dill_suffix_detach")
      import :: c_int, c_int64_t
      integer(c_int), value, intent(in) :: socket
      integer(c_int64_t), value, intent(in) :: deadline
    end function suffix_detach

    integer(c_int) function msend(socket, buf, length, deadline) bind(c, name = "dill_msend")
      import :: c_int, c_size_t, c_char, c_int64_t
      integer(c_int), value, intent(in) :: socket
      character(c_char), intent(in) :: buf(*)
      integer(c_size_t), value, intent(in) :: length
      integer(c_int64_t), intent(in) :: deadline
    end function msend


    !> convert a C string to a fortran string cutting the characters that follow the null char
    module function from_c(string)
        character(len=*) :: string
        character(len=len(string)) :: from_c
    end function from_c 

  end interface

end module m_dill
