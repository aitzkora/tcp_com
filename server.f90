program server
  use iso_c_binding, only : c_int, c_null_char, c_char, c_int64_t, c_size_t
  use m_dill, only : ipaddr, ipaddr_local, IPADDR_IPV4, ipaddr_str, ipaddr_port, & 
                     from_c, tcp_listen, tcp_accept, tcp_close, TCP_SUFFIX, &
                     suffix_detach, suffix_attach, msend

  implicit none
  integer(c_int) :: rc, socket, connection
  type(ipaddr) :: addr
  character(len=128, kind=c_char) :: address

  rc = ipaddr_local( addr, '127.0.0.1' // c_null_char , 5555_c_int, IPADDR_IPV4 )

  call ipaddr_str( addr, address )
  
  socket = tcp_listen( addr, 0_c_int )
  print '(ai0)', "socket = ", socket
  
  do 
    connection = tcp_accept( socket, addr, 0_c_int64_t )
    if (connection /= -1) then
      call ipaddr_str(addr, address)
      print '(aa)', 'Connection from', from_c( address )
      connection = suffix_attach( connection, TCP_SUFFIX,  2_c_size_t )
      rc = msend( connection, "Hello" // c_null_char , 5_c_size_t, -1_c_int64_t )
      connection = suffix_detach( connection, -1_c_int64_t )
      rc = tcp_close(connection, -1_c_int64_t)
    end if
  end do  
end program server
