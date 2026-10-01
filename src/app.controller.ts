import { Controller, Get, Query } from '@nestjs/common';
import { AppService } from './app.service.js';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  info() {
    return this.appService.getInfo();
  }

  @Get('health')
  health() {
    return this.appService.health();
  }

  @Get('stats')
  stats() {
    return this.appService.stats();
  }

  @Get('movies')
  movies(@Query('take') take?: string) {
    return this.appService.movies(Number(take ?? 20));
  }

  @Get('cinemas')
  cinemas(@Query('take') take?: string) {
    return this.appService.cinemas(Number(take ?? 20));
  }
}
