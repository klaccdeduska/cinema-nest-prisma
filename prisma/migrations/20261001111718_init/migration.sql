-- CreateTable
CREATE TABLE `cinemas` (
    `cinema_id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(30) NULL,
    `email` VARCHAR(254) NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_on` DATETIME(0) NOT NULL,

    PRIMARY KEY (`cinema_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `genres` (
    `genre_id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL,

    PRIMARY KEY (`genre_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `halls` (
    `hall_id` BIGINT NOT NULL AUTO_INCREMENT,
    `cinema_id` BIGINT NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `screen_type` VARCHAR(20) NOT NULL,
    `capacity` INTEGER NOT NULL,

    PRIMARY KEY (`hall_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `movies` (
    `movie_id` BIGINT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(200) NOT NULL,
    `description` TEXT NULL,
    `duration_minutes` SMALLINT NOT NULL,
    `release_date` DATE NOT NULL,
    `age_rating` VARCHAR(10) NOT NULL,
    `language` VARCHAR(50) NOT NULL,
    `country` VARCHAR(40) NOT NULL,

    PRIMARY KEY (`movie_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `movie_genres` (
    `movie_id` BIGINT NOT NULL,
    `genre_id` BIGINT NOT NULL,

    PRIMARY KEY (`movie_id`, `genre_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `people` (
    `person_id` BIGINT NOT NULL AUTO_INCREMENT,
    `full_name` VARCHAR(100) NOT NULL,
    `birth_date` DATE NOT NULL,
    `biography` TEXT NULL,

    PRIMARY KEY (`person_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `movie_cast` (
    `movie_id` BIGINT NOT NULL,
    `person_id` BIGINT NOT NULL,
    `characher_name` VARCHAR(150) NOT NULL,

    PRIMARY KEY (`movie_id`, `person_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `movie_crew` (
    `movie_id` BIGINT NOT NULL,
    `person_id` BIGINT NOT NULL,
    `role` VARCHAR(30) NOT NULL,

    PRIMARY KEY (`person_id`, `movie_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `screenings` (
    `screening_id` BIGINT NOT NULL AUTO_INCREMENT,
    `movie_id` BIGINT NOT NULL,
    `hall_id` BIGINT NOT NULL,
    `starts_at` DATETIME(0) NOT NULL,
    `ends_at` DATETIME(0) NOT NULL,
    `format` VARCHAR(20) NOT NULL,
    `price` INTEGER NOT NULL,

    PRIMARY KEY (`screening_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `seats` (
    `seat_id` BIGINT NOT NULL AUTO_INCREMENT,
    `hall_id` BIGINT NOT NULL,
    `row_number` SMALLINT NOT NULL,
    `seat_number` SMALLINT NOT NULL,
    `seat_type` VARCHAR(20) NOT NULL,

    PRIMARY KEY (`seat_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `users` (
    `user_id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(1024) NOT NULL,
    `birth_date` DATE NOT NULL,
    `email` VARCHAR(254) NOT NULL,
    `updated_at` DATETIME(0) NOT NULL,
    `password` VARCHAR(2048) NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `users_pk`(`email`),
    PRIMARY KEY (`user_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `bookings` (
    `booking_id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `screening_id` BIGINT NOT NULL,
    `status` VARCHAR(20) NOT NULL,
    `booked_at` DATETIME(0) NOT NULL,
    `expires_at` DATETIME(0) NULL,

    PRIMARY KEY (`booking_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `news` (
    `news_id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `content` TEXT NOT NULL,
    `published_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(0) NOT NULL,

    PRIMARY KEY (`news_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `reviews` (
    `review_id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `movie_id` BIGINT NOT NULL,
    `rating` SMALLINT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `body` TEXT NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_on` DATETIME(0) NOT NULL,

    PRIMARY KEY (`review_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tickets` (
    `tickets_id` BIGINT NOT NULL AUTO_INCREMENT,
    `booking_id` BIGINT NOT NULL,
    `screening_id` BIGINT NOT NULL,
    `seat_id` BIGINT NOT NULL,
    `price` INTEGER NOT NULL,
    `status` VARCHAR(20) NOT NULL,
    `issued_at` DATETIME(0) NOT NULL,

    UNIQUE INDEX `tickets_pk`(`screening_id`),
    UNIQUE INDEX `tickets_pk_2`(`seat_id`),
    PRIMARY KEY (`tickets_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `halls` ADD CONSTRAINT `halls_cinemas_cinema_id_fk` FOREIGN KEY (`cinema_id`) REFERENCES `cinemas`(`cinema_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movie_genres` ADD CONSTRAINT `movie_genres_movies_movie_id_fk` FOREIGN KEY (`movie_id`) REFERENCES `movies`(`movie_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movie_genres` ADD CONSTRAINT `movie_genres_genres_genre_id_fk` FOREIGN KEY (`genre_id`) REFERENCES `genres`(`genre_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movie_cast` ADD CONSTRAINT `movie_cast_movies_movie_id_fk` FOREIGN KEY (`movie_id`) REFERENCES `movies`(`movie_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movie_cast` ADD CONSTRAINT `movie_cast_people_person_id_fk` FOREIGN KEY (`person_id`) REFERENCES `people`(`person_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movie_crew` ADD CONSTRAINT `movie_crew_movies_movie_id_fk` FOREIGN KEY (`movie_id`) REFERENCES `movies`(`movie_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movie_crew` ADD CONSTRAINT `movie_crew_people_person_id_fk` FOREIGN KEY (`person_id`) REFERENCES `people`(`person_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `screenings` ADD CONSTRAINT `screenings_halls_hall_id_fk` FOREIGN KEY (`hall_id`) REFERENCES `halls`(`hall_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `screenings` ADD CONSTRAINT `screenings_movies_movie_id_fk` FOREIGN KEY (`movie_id`) REFERENCES `movies`(`movie_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `seats` ADD CONSTRAINT `seats_halls_hall_id_fk` FOREIGN KEY (`hall_id`) REFERENCES `halls`(`hall_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `bookings` ADD CONSTRAINT `bookings_screenings_screening_id_fk` FOREIGN KEY (`screening_id`) REFERENCES `screenings`(`screening_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `bookings` ADD CONSTRAINT `bookings_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `news` ADD CONSTRAINT `news_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reviews` ADD CONSTRAINT `reviews_movies_movie_id_fk` FOREIGN KEY (`movie_id`) REFERENCES `movies`(`movie_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reviews` ADD CONSTRAINT `reviews_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tickets` ADD CONSTRAINT `tickets_bookings_booking_id_fk` FOREIGN KEY (`booking_id`) REFERENCES `bookings`(`booking_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tickets` ADD CONSTRAINT `tickets_screenings_screening_id_fk` FOREIGN KEY (`screening_id`) REFERENCES `screenings`(`screening_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tickets` ADD CONSTRAINT `tickets_seats_seat_id_fk` FOREIGN KEY (`seat_id`) REFERENCES `seats`(`seat_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
