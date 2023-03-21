conn = database('localhost','root','');
%%curs = exec(conn,'SELECT * FROM user');
%%curs = fetch(curs);
%%curs.Data

 notAccepted = 1;
 rejected = num2str(notAccepted);
  query = ['UPDATE banana_process SET total = ', rejected, ' WHERE id = 3'];
  exec(conn, query);
              
%% mathworks.com/products/database/driver-installation.html
%% Update user set name='Sample' where id=1
%% update(conn,'banana_process',{'Reject'},{'1'},{'WHERE id=3'});
