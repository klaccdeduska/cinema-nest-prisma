import 'dotenv/config';
import { faker } from '@faker-js/faker';
import { PrismaMariaDb } from '@prisma/adapter-mariadb';
import { PrismaClient } from '../src/generated/prisma/client.js';

const adapter = new PrismaMariaDb({
  host: process.env.DATABASE_HOST ?? 'localhost',
  port: Number(process.env.DATABASE_PORT ?? 33061),
  user: process.env.DATABASE_USER ?? 'cinema',
  password: process.env.DATABASE_PASSWORD ?? 'cinema',
  database: process.env.DATABASE_NAME ?? 'cinema',
  connectionLimit: 5,
});

const prisma = new PrismaClient({ adapter });
const ROWS = 100;

const formats = ['2D', '3D', 'IMAX', '4DX'];
const screenTypes = ['Standard', 'IMAX', 'Dolby', 'VIP'];
const ageRatings = ['L', 'PG', 'PG-13', '16+', '18+'];
const seatTypes = ['standard', 'vip', 'recliner'];
const bookingStatuses = ['reserved', 'paid', 'cancelled'];
const ticketStatuses = ['valid', 'used', 'cancelled'];
const crewRoles = ['Director', 'Producer', 'Writer', 'Editor', 'Composer'];
const languages = ['English', 'Estonian', 'Russian', 'Finnish', 'German'];

async function clearDatabase() {
  await prisma.ticket.deleteMany();
  await prisma.review.deleteMany();
  await prisma.news.deleteMany();
  await prisma.booking.deleteMany();
  await prisma.movieCrew.deleteMany();
  await prisma.movieCast.deleteMany();
  await prisma.movieGenre.deleteMany();
  await prisma.screening.deleteMany();
  await prisma.seat.deleteMany();
  await prisma.hall.deleteMany();
  await prisma.person.deleteMany();
  await prisma.genre.deleteMany();
  await prisma.movie.deleteMany();
  await prisma.user.deleteMany();
  await prisma.cinema.deleteMany();
}

async function main() {
  faker.seed(20261001);
  console.log('Clearing old data...');
  await clearDatabase();

  const cinemas = [];
  const genres = [];
  const movies = [];
  const people = [];
  const users = [];

  for (let i = 0; i < ROWS; i++) {
    cinemas.push(
      await prisma.cinema.create({
        data: {
          name: `${faker.company.name()} Cinema ${i + 1}`,
          address: faker.location.streetAddress(),
          phone: faker.phone.number(),
          email: `cinema-${i + 1}@example.test`,
        },
      }),
    );

    genres.push(
      await prisma.genre.create({
        data: { name: `${faker.word.adjective()}-${faker.word.noun()}-${i + 1}`.slice(0, 40) },
      }),
    );

    movies.push(
      await prisma.movie.create({
        data: {
          title: `${faker.lorem.words({ min: 2, max: 5 })} ${i + 1}`.slice(0, 200),
          description: faker.lorem.paragraph(),
          durationMinutes: faker.number.int({ min: 75, max: 190 }),
          releaseDate: faker.date.between({ from: new Date('1980-01-01'), to: new Date() }),
          ageRating: faker.helpers.arrayElement(ageRatings),
          language: faker.helpers.arrayElement(languages),
          country: faker.location.country().slice(0, 40),
        },
      }),
    );

    people.push(
      await prisma.person.create({
        data: {
          fullName: faker.person.fullName().slice(0, 100),
          birthDate: faker.date.birthdate({ min: 18, max: 80, mode: 'age' }),
          biography: faker.lorem.paragraph(),
        },
      }),
    );

    users.push(
      await prisma.user.create({
        data: {
          name: faker.person.fullName(),
          birthDate: faker.date.birthdate({ min: 16, max: 80, mode: 'age' }),
          email: `user-${i + 1}@example.test`,
          password: `demo-password-${i + 1}`,
        },
      }),
    );
  }

  const halls = [];
  for (let i = 0; i < ROWS; i++) {
    halls.push(
      await prisma.hall.create({
        data: {
          cinemaId: cinemas[i].cinemaId,
          name: `Hall ${i + 1}`,
          screenType: faker.helpers.arrayElement(screenTypes),
          capacity: faker.number.int({ min: 50, max: 400 }),
        },
      }),
    );
  }

  const seats = [];
  for (let i = 0; i < ROWS; i++) {
    seats.push(
      await prisma.seat.create({
        data: {
          hallId: halls[i].hallId,
          rowNumber: faker.number.int({ min: 1, max: 20 }),
          seatNumber: faker.number.int({ min: 1, max: 30 }),
          seatType: faker.helpers.arrayElement(seatTypes),
        },
      }),
    );
  }

  const screenings = [];
  for (let i = 0; i < ROWS; i++) {
    const startsAt = faker.date.soon({ days: 90 });
    const endsAt = new Date(startsAt.getTime() + movies[i].durationMinutes * 60_000);

    screenings.push(
      await prisma.screening.create({
        data: {
          movieId: movies[i].movieId,
          hallId: halls[i].hallId,
          startsAt,
          endsAt,
          format: faker.helpers.arrayElement(formats),
          price: faker.number.int({ min: 7, max: 25 }),
        },
      }),
    );
  }

  for (let i = 0; i < ROWS; i++) {
    await prisma.movieGenre.create({
      data: {
        movieId: movies[i].movieId,
        genreId: genres[i].genreId,
      },
    });

    await prisma.movieCast.create({
      data: {
        movieId: movies[i].movieId,
        personId: people[i].personId,
        characterName: `${faker.person.firstName()} ${faker.person.lastName()}`.slice(0, 150),
      },
    });

    await prisma.movieCrew.create({
      data: {
        movieId: movies[i].movieId,
        personId: people[(i + 1) % ROWS].personId,
        role: faker.helpers.arrayElement(crewRoles),
      },
    });
  }

  const bookings = [];
  for (let i = 0; i < ROWS; i++) {
    const bookedAt = faker.date.recent({ days: 30 });
    bookings.push(
      await prisma.booking.create({
        data: {
          userId: users[i].userId,
          screeningId: screenings[i].screeningId,
          status: faker.helpers.arrayElement(bookingStatuses),
          bookedAt,
          expiresAt: new Date(bookedAt.getTime() + 30 * 60_000),
        },
      }),
    );

    await prisma.news.create({
      data: {
        userId: users[i].userId,
        title: faker.lorem.sentence({ min: 3, max: 8 }).slice(0, 200),
        content: faker.lorem.paragraphs({ min: 1, max: 3 }),
      },
    });

    await prisma.review.create({
      data: {
        userId: users[i].userId,
        movieId: movies[i].movieId,
        rating: faker.number.int({ min: 1, max: 10 }),
        title: faker.lorem.sentence({ min: 2, max: 6 }).slice(0, 200),
        body: faker.lorem.paragraph(),
      },
    });
  }

  for (let i = 0; i < ROWS; i++) {
    await prisma.ticket.create({
      data: {
        bookingId: bookings[i].bookingId,
        screeningId: screenings[i].screeningId,
        seatId: seats[i].seatId,
        price: screenings[i].price,
        status: faker.helpers.arrayElement(ticketStatuses),
        issuedAt: faker.date.recent({ days: 10 }),
      },
    });
  }

  const stats = {
    cinemas: await prisma.cinema.count(),
    genres: await prisma.genre.count(),
    halls: await prisma.hall.count(),
    movies: await prisma.movie.count(),
    movie_genres: await prisma.movieGenre.count(),
    people: await prisma.person.count(),
    movie_cast: await prisma.movieCast.count(),
    movie_crew: await prisma.movieCrew.count(),
    screenings: await prisma.screening.count(),
    seats: await prisma.seat.count(),
    users: await prisma.user.count(),
    bookings: await prisma.booking.count(),
    news: await prisma.news.count(),
    reviews: await prisma.review.count(),
    tickets: await prisma.ticket.count(),
  };

  console.table(stats);
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
