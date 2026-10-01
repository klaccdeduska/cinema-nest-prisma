create table cinemas
(
    cinema_id  bigint auto_increment
        primary key,
    name       varchar(100)                         not null,
    address    varchar(255)                         not null,
    phone      varchar(30)                          null,
    email      varchar(254)                         null,
    created_at datetime default current_timestamp() not null,
    updated_on datetime default current_timestamp() null on update current_timestamp()
);

create table genres
(
    genre_id bigint auto_increment
        primary key,
    name     varchar(40) not null
);

create table halls
(
    hall_id     bigint auto_increment
        primary key,
    cinema_id   bigint      not null,
    name        varchar(50) not null,
    screen_type varchar(20) not null,
    capacity    int         not null,
    constraint halls_cinemas_cinema_id_fk
        foreign key (cinema_id) references cinemas (cinema_id)
);

create table movies
(
    movie_id         bigint auto_increment
        primary key,
    title            varchar(200) not null,
    description      text         null,
    duration_minutes smallint     not null,
    release_date     date         not null,
    age_rating       varchar(10)  not null,
    language         varchar(50)  not null,
    country          varchar(40)  not null
);

create table movie_genres
(
    movie_id bigint not null,
    genre_id bigint not null,
    primary key (movie_id, genre_id),
    constraint movie_genres_genres_genre_id_fk
        foreign key (genre_id) references genres (genre_id),
    constraint movie_genres_movies_movie_id_fk
        foreign key (movie_id) references movies (movie_id)
);

create table people
(
    person_id  bigint auto_increment
        primary key,
    full_name  varchar(100) not null,
    birth_date date         not null,
    biography  text         null
);

create table movie_cast
(
    movie_id       bigint       not null,
    person_id      bigint       not null,
    characher_name varchar(150) not null,
    primary key (movie_id, person_id),
    constraint movie_cast_movies_movie_id_fk
        foreign key (movie_id) references movies (movie_id),
    constraint movie_cast_people_person_id_fk
        foreign key (person_id) references people (person_id)
);

create table movie_crew
(
    movie_id  bigint      not null,
    person_id bigint      not null,
    role      varchar(30) not null,
    primary key (person_id, movie_id),
    constraint movie_crew_movies_movie_id_fk
        foreign key (movie_id) references movies (movie_id),
    constraint movie_crew_people_person_id_fk
        foreign key (person_id) references people (person_id)
);

create table screenings
(
    screening_id bigint auto_increment
        primary key,
    movie_id     bigint      not null,
    hall_id      bigint      not null,
    starts_at    datetime    not null,
    ends_at      datetime    not null,
    format       varchar(20) not null,
    price        int(5)      not null,
    constraint screenings_halls_hall_id_fk
        foreign key (hall_id) references halls (hall_id),
    constraint screenings_movies_movie_id_fk
        foreign key (movie_id) references movies (movie_id)
);

create table seats
(
    seat_id      bigint auto_increment
        primary key,
    hall_id      bigint      not null,
    `row_number` smallint    not null,
    seat_number  smallint    not null,
    seat_type    varchar(20) not null,
    constraint seats_halls_hall_id_fk
        foreign key (hall_id) references halls (hall_id)
);

create table users
(
    user_id    bigint auto_increment
        primary key,
    name       varchar(1024)                        not null,
    birth_date date                                 not null,
    email      varchar(254)                         not null,
    updated_at datetime default current_timestamp() null on update current_timestamp(),
    password   varchar(2048)                        not null,
    created_at datetime default current_timestamp() null,
    constraint users_pk
        unique (email)
);

create table bookings
(
    booking_id   bigint auto_increment
        primary key,
    user_id      bigint      not null,
    screening_id bigint      not null,
    status       varchar(20) not null,
    booked_at    datetime    not null,
    expires_at   datetime    null,
    constraint bookings_screenings_screening_id_fk
        foreign key (screening_id) references screenings (screening_id),
    constraint bookings_users_user_id_fk
        foreign key (user_id) references users (user_id)
);

create table news
(
    news_id      bigint auto_increment
        primary key,
    user_id      bigint                               not null,
    title        varchar(200)                         not null,
    content      text                                 not null,
    published_at datetime default current_timestamp() null,
    updated_at   datetime default current_timestamp() null on update current_timestamp(),
    constraint news_users_user_id_fk
        foreign key (user_id) references users (user_id)
);

create table reviews
(
    review_id  bigint auto_increment
        primary key,
    user_id    bigint                               not null,
    movie_id   bigint                               not null,
    rating     smallint                             not null,
    title      varchar(200)                         not null,
    body       text                                 null,
    created_at datetime default current_timestamp() not null,
    updated_on datetime default current_timestamp() null on update current_timestamp(),
    constraint reviews_movies_movie_id_fk
        foreign key (movie_id) references movies (movie_id),
    constraint reviews_users_user_id_fk
        foreign key (user_id) references users (user_id)
);

create table tickets
(
    tickets_id   bigint auto_increment
        primary key,
    booking_id   bigint      not null,
    screening_id bigint      not null,
    seat_id      bigint      not null,
    price        int(6)      not null,
    status       varchar(20) not null,
    issued_at    datetime    not null,
    constraint tickets_pk
        unique (screening_id),
    constraint tickets_pk_2
        unique (seat_id),
    constraint tickets_bookings_booking_id_fk
        foreign key (booking_id) references bookings (booking_id),
    constraint tickets_screenings_screening_id_fk
        foreign key (screening_id) references screenings (screening_id),
    constraint tickets_seats_seat_id_fk
        foreign key (seat_id) references seats (seat_id)
);

