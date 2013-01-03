# Use Cases

## User starts session
Data: None
1. System creates a session for user

## Active User Session
Data: <user_id>
1. System checks if session is still open for user

## User gives input
Data: <user_id> <expression>
1. System gets session for user
2. System evaluates expression in users session
3. System returns evaluated expression

## Close session
Data: <user_id>
1. System closes session for user
