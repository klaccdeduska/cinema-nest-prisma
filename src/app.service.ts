import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma/prisma.service.js';

@Injectable()
export class AppService {
  constructor(private readonly prisma: PrismaService) {}

  getInfo() {
    return {
      project: 'Cinema API',
      backend: 'NestJS',
      orm: 'Prisma ORM',
      database: 'MariaDB / MySQL',
      endpoints: ['/health', '/stats', '/movies', '/cinemas'],
    };
  }

  async health() {
    await this.prisma.$queryRaw`SELECT 1`;
    return { status: 'ok', database: 'connected' };
  }

  async stats() {
    const [
      cinemas,
      genres,
      halls,
      movies,
      movieGenres,
      people,
      movieCast,
      movieCrew,
      screenings,
      seats,
      users,
      bookings,
      news,
      reviews,
      tickets,
    ] = await Promise.all([
      this.prisma.cinema.count(),
      this.prisma.genre.count(),
      this.prisma.hall.count(),
      this.prisma.movie.count(),
      this.prisma.movieGenre.count(),
      this.prisma.person.count(),
      this.prisma.movieCast.count(),
      this.prisma.movieCrew.count(),
      this.prisma.screening.count(),
      this.prisma.seat.count(),
      this.prisma.user.count(),
      this.prisma.booking.count(),
      this.prisma.news.count(),
      this.prisma.review.count(),
      this.prisma.ticket.count(),
    ]);

    return {
      cinemas,
      genres,
      halls,
      movies,
      movie_genres: movieGenres,
      people,
      movie_cast: movieCast,
      movie_crew: movieCrew,
      screenings,
      seats,
      users,
      bookings,
      news,
      reviews,
      tickets,
    };
  }

  async movies(take = 20) {
    return this.prisma.movie.findMany({
      take: Math.min(Math.max(take, 1), 100),
      include: {
        genres: { include: { genre: true } },
      },
      orderBy: { movieId: 'asc' },
    });
  }

  async cinemas(take = 20) {
    return this.prisma.cinema.findMany({
      take: Math.min(Math.max(take, 1), 100),
      include: { halls: true },
      orderBy: { cinemaId: 'asc' },
    });
  }
}
