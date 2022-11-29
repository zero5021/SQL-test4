/*link para el video: https://youtu.be/e1WV-jZ6CIU*/

/*Creamos la base de datos y realizamos la coneccion*/

CREATE DATABASE luis_urbaneja_259;
\c luis_urbaneja_259;

/*Creamos las tablas de nuestras base de datos*/

CREATE TABLE films (films_id BIGSERIAL NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL, year INT NOT NULL);
CREATE TABLE tags (tags_id BIGSERIAL NOT NULL PRIMARY KEY, tag VARCHAR(32) NOT NULL);
CREATE TABLE films_tags (films_id BIGINT REFERENCES films(films_id), tags_id BIGINT REFERENCES tags(tags_id));

/*Insertamos toda la informacion referente en nuestras tablas ya creadas*/

INSERT INTO films(name, year) VALUES ('spaceJAM', 1996), ('IRONMAN', 2008), ('FIESTA DE LA SALCHICHA', 2016), ('Harry Potter y la piedra filosofal', 2001),('SAW 1', 2004);
INSERT INTO tags(tag) VALUES ('DIBUJOS ANIMADOS'), ('ACCION'), ('ANIMADA'), ('FANTASIA'), ('SUSPENSO');
INSERT INTO films_tags(films_id, tags_id) VALUES (1, 1),(1, 2), (1, 3), (2, 1), (2, 4);

/*verificamos los datos de nuestras tablas*/
SELECT * FROM films;
SELECT * FROM tags;
SELECT * FROM films_tags;

/*Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0*/

SELECT films.name, COUNT(tags) as tags FROM films LEFT JOIN films_tags USING (films_id) LEFT JOIN tags USING (tags_id) GROUP BY films.name;

/*Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y  tipos de datos.*/

CREATE TABLE questions (id SERIAL PRIMARY KEY, question VARCHAR (255), good_answer VARCHAR);
CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(255), age INT);
CREATE TABLE answers (  id SERIAL PRIMARY KEY, answer VARCHAR (255), user_id INT, question_id INT, FOREIGN KEY ("user_id") REFERENCES users(id), FOREIGN KEY ("question_id") REFERENCES questions(id));

/*Agregamos los datos, 5 usuarios y 5 preguntas*/

/*preguntas*/
INSERT INTO questions (question, good_answer) VALUES ('¿Los perros pueden nadar?', 'si'), ('¿las galletas son dulces?', 'si'), ('¿los gallinas vuelan?', 'no'), ('¿2+2 es igual a 2 al cubo?', 'no'), ('¿pasaremos el desafio latam?', 'claro que si');

/*usuarios*/
INSERT INTO users (name, age) VALUES ('luis', 30),('zero', 27),('Marianela', 30), ('pavel', 29),('ledymar', 28);

/*respuestas
1. Primera pregunta debe estar contestada dos veces por distintos usuarios.
2. Segunda pregunta debe estar contestada solo por un usuario.
3. Las otras dos incorrectas
*/
INSERT INTO answers(answer, user_id, question_id) VALUES('si',1,1), ('si',2,1), ('no', 4,3), ('si', 5,4), ('no lo se rick', 3,5);

/*Comprobamos que los datos hayan sido cargados visualmente*/
SELECT * FROM questions;
SELECT * FROM users;
SELECT * FROM answers;

/* Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).*/

SELECT users.name, COUNT(answers.answer) as good_answer FROM questions INNER JOIN answers ON questions.id = answers.question_id INNER JOIN users ON answers.user_id = users.id WHERE questions.good_answer = answers.answer GROUP BY  users.name;

/*Por  cada  pregunta,  en  la  tabla  preguntas,  
cuenta  cuántos  usuarios  tuvieron la respuesta correcta*/

SELECT questions.question, COUNT (users.id) AS users FROM users INNER JOIN answers ON users.id = answers.user_id INNER JOIN questions ON answers.question_id = questions.id WHERE questions.good_answer = answers.answer GROUP BY questions.question; 


/*Implementa borrado en cascada de las respuestas al borrar a el primer usuario para probar la implementación.*/

ALTER TABLE answers DROP CONSTRAINT answers_user_id_fkey, ADD FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

/*--borrando a el primer usuario--*/
DELETE FROM users WHERE id= 1;   

/* Verificacion de la eliminacion de datos en las tablas*/
SELECT * FROM users;

SELECT users.name, COUNT(answers.answer) as good_answer FROM questions INNER JOIN answers ON questions.id = answers.question_id INNER JOIN users ON answers.user_id = users.id WHERE questions.good_answer = answers.answer GROUP BY  users.name;

SELECT questions.question, COUNT (users.id) AS users FROM users INNER JOIN answers ON users.id = answers.user_id INNER JOIN questions ON answers.question_id = questions.id WHERE questions.good_answer = answers.answer GROUP BY questions.question; 

/*Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos*/

/*--sin restriccciones podemos introducir a cualquier usuario en nuestras tablas y si intentamos poner alguna alteracion de la tabla esta no nos permite--*/
INSERT INTO users (name, age) VALUES ('luis', 16);
SELECT * FROM users;
ALTER TABLE users ADD CHECK (age >= 18);
DELETE FROM users WHERE id= 6;

/*--pero al alterar la tabla de usuarios y colocar el chequeo ya no se puede--*/
ALTER TABLE users ADD CHECK (age >= 18);
SELECT * FROM users;

/* Verificamos que la nueva condicion se cumpla al intentar ingresar un registroa la tabla usuarios*/
INSERT INTO users (name, age) VALUES ('luis', 16);

/*Altera la tabla existente de usuarios agregando el campo email con la restricción de 
único.*/

ALTER TABLE users ADD COLUMN email VARCHAR(30) UNIQUE; 
SELECT * FROM users;

/* Verificacion de la adicion de la nueva columna en la tabla usuarios*/
INSERT INTO users (name, age, email) VALUES ('luis', 25, 'correo@prueba');
SELECT * FROM users;