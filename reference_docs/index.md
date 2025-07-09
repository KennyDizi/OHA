# Reference Documentation

This directory contains comprehensive reference documentation for the OHA project.

## Available Documents

### [FastAPI Best Practices](./fastapi-best-practices.md)

A comprehensive guide to FastAPI best practices and conventions based on real-world production experience. This document covers:

- **Project Structure**: Scalable domain-driven architecture inspired by Netflix's Dispatch
- **Async Routes**: Best practices for handling I/O intensive vs CPU intensive tasks
- **Pydantic**: Advanced usage patterns including custom base models and decoupled settings
- **Dependencies**: Beyond dependency injection, chaining dependencies, and caching strategies
- **Miscellaneous**: REST conventions, response serialization, database practices, testing, and more

Key topics include:
- When to use async vs sync routes and their performance implications
- How to structure large FastAPI applications with multiple domains
- Advanced Pydantic patterns for validation and serialization
- Dependency injection strategies for complex validation scenarios
- Database naming conventions and migration best practices
- Testing strategies with async clients

This guide is particularly valuable for teams building production FastAPI applications and provides practical insights from years of real-world usage.

## Additional Resources

- **Images**: The `fastapi-best-practices-images/` directory contains supporting images and screenshots referenced in the FastAPI best practices guide.

