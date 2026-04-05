import Phaser from 'phaser';

export class BootScene extends Phaser.Scene {
  constructor() {
    super({ key: 'BootScene' });
  }

  create(): void {
    const { width, height } = this.scale;

    this.add
      .text(width / 2, height / 2 - 40, 'DUNGEON HAUL', {
        fontSize: '48px',
        color: '#e94560',
        fontFamily: 'monospace',
      })
      .setOrigin(0.5);

    this.add
      .text(width / 2, height / 2 + 20, '던전 루터 서바이버', {
        fontSize: '20px',
        color: '#8b8b8b',
        fontFamily: 'monospace',
      })
      .setOrigin(0.5);

    this.add
      .text(width / 2, height / 2 + 80, 'Press any key to start', {
        fontSize: '16px',
        color: '#4a4a6a',
        fontFamily: 'monospace',
      })
      .setOrigin(0.5);
  }
}
