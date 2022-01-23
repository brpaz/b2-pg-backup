module.exports = {
  branches: ['main'],
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/changelog',
    '@semantic-release/git',
    '@semantic-release/github',
    [
      '@eclass/semantic-release-docker',
      {
        baseImageName: process.env.DOCKER_IMAGE_NAME,
        baseImageTag: process.env.DOCKER_IMAGE_TAG,
        registries: [
          {
            url: 'docker.io',
            imageName: `docker.io/${process.env.DOCKER_IMAGE_NAME}`,
            user: 'DOCKER_USER',
            password: 'DOCKER_PASSWORD',
          },
          {
            url: 'ghcr.io',
            imageName: `ghcr.io/${process.env.DOCKER_IMAGE_NAME}`,
            user: 'GITHUB_USER',
            password: 'GITHUB_TOKEN',
          },
        ],
      },
    ],
  ],
};
