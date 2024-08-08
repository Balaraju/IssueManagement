# GitHub App for Issue Time Estimate Reminder

## Setup

1. **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/your-repo-name.git
    cd your-repo-name
    ```

2. **Install dependencies**:
    ```bash
    bundle install
    ```

3. **Configure environment variables**:
    Create a `.env` file with the following content:
    ```env
    GITHUB_APP_IDENTIFIER=your-app-id
    GITHUB_PRIVATE_KEY_PATH=path-to-your-private-key
    SMEE_URL=https://smee.io/your-smee-channel
    ```

4. **Run the application**:
    ```bash
    bundle exec rackup
    ```

## Usage

- Ensure the GitHub app is installed on a repository.
- The app listens for new issue events and checks for an estimate in the format "Estimate: X days".
- If the estimate is missing, the app comments on the issue to remind the creator to add it.
