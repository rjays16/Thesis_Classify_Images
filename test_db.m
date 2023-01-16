conn = database('thesis','root','');
curs = exec(conn,'SELECT * FROM user');
curs = fetch(curs);
curs.Data

%% Update user set name='Sample' where id=1
update(conn,'user',{'name'},{'Buang'},{'WHERE id=1'});
