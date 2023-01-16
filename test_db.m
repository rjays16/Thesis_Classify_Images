conn = database('thesis','root','');
curs = exec(conn,'SELECT * FROM user');
curs = fetch(curs);
curs.Data

%% mathworks.com/products/database/driver-installation.html
%% Update user set name='Sample' where id=1
update(conn,'user',{'name'},{'Sample'},{'WHERE id=1'});
