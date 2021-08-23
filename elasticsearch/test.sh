for (( i = 0; i < 100; i++ )); do
	#statements
	curl -X POST "localhost:9200/test/user" -H "Content-Type: application/json" -d '{"first_name" : "zhang {'$i'}","last_name" : "jerry","age" : '$((i+20))',"abort" : "a man"}'
	
done

#curl -X POST "localhost:9200/test_user/user" -H "Content-Type: application/json" -d '{"first_name" : "zhang 1","last_name" : "jerry","age" : '{$i}',"abort" : "a man"}'