conn = database('thesis','root','');
curs = exec(conn,'SELECT * FROM user');
curs = fetch(curs);
curs.Data

%% mathworks.com/products/database/driver-installation.html
%% Update user set name='Sample' where id=1
status = 1;
query = 'UPDATE status_table SET status = 1 WHERE id = 1';
exec(conn,query);
close(conn)