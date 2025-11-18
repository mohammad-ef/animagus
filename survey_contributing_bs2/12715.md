# Contributing Guidelines

Thank you for your interest in contributing to our project. Whether it's a bug report, new feature, correction, or additional
documentation, we greatly value feedback and contributions from our community.

Please read through this document before submitting any issues or pull requests to ensure we have all the necessary
information to effectively respond to your bug report or contribution.

## Contributing Flow Templates

### Step 1: Create Flow Definition

1. Design your flow in the AWS Bedrock Flow console
2. Export the flow definition as JSON
3. Verify the flow works as expected

### Step 2: Prepare Template Variables

1. Identify dynamic values in your flow (e.g., model IDs, knowledge base IDs)
2. Replace these values with template variables using the format: `$$VARIABLE_NAME`
   Example variables:
   - `$$MODEL_ID` - For Bedrock model IDs
   - `$$KNOWLEDGE_BASE_ID` - For knowledge base references
   - `$$ROLE_ARN` - For IAM role ARNs
   - `$$FLOW_NAME` - For customizable flow names

### Step 3: Create Template File

1. Create a new JSON file in the `./templates` directory
2. Include the following structure:

```json
{
    "name": "Your Flow Name",
    "description": "Detailed description of what the flow does",
    "tags": {
        "Category": "value",
        "UseCase": "value"
    },
    "definition": {
        // Your flow definition here
    }
}
```

### Step 4: Add Documentation

1. Take a screenshot of your flow from the AWS Bedrock Flow console
2. Save the image in the
`docs/images`
directory with a descriptive name
3. Update the README.md to include:

- Description of your template
- Flow diagram image
- Required variables
- Example usage

### Step 5: Test and Verify

1. Test the template using the provided tools
2. Verify all variables are properly replaced
3. Ensure the flow works as expected
4. Update documentation based on testing

### Step 6: Submit Pull Request

1. Create a new branch for your contribution
2. Commit your changes with clear messages
3. Submit a pull request including:

- Description of the new template
- Screenshot of the flow
- List of required variables
- Test results
- Any additional documentation

## Reporting Bugs/Feature Requests

We welcome you to use the GitHub issue tracker to report bugs or suggest features.

When filing an issue, please check existing open, or recently closed, issues to make sure somebody else hasn't already
reported the issue. Please try to include as much information as you can. Details like these are incredibly useful:

* A reproducible test case or series of steps
* The version of our code being used
* Any modifications you've made relevant to the bug
* Anything unusual about your environment or deployment


## Contributing via Pull Requests
Contributions via pull requests are much appreciated. Before sending us a pull request, please ensure that:

1. You are working against the latest source on the *main* branch.
2. You check existing open, and recently merged, pull requests to make sure someone else hasn't addressed the problem already.
3. You open an issue to discuss any significant work - we would hate for your time to be wasted.

To send us a pull request, please:

1. Fork the repository.
2. Modify the source; please focus on the specific change you are contributing. If you also reformat all the code, it will be hard for us to focus on your change.
3. Ensure local tests pass.
4. Commit to your fork using clear commit messages.
5. Send us a pull request, answering any default questions in the pull request interface.
6. Pay attention to any automated CI failures reported in the pull request, and stay involved in the conversation.

GitHub provides additional document on [forking a repository](https://help.github.com/articles/fork-a-repo/) and
[creating a pull request](https://help.github.com/articles/creating-a-pull-request/).

## Finding contributions to work on
Looking at the existing issues is a great way to find something to contribute on. As our projects, by default, use the default GitHub issue labels (enhancement/bug/duplicate/help wanted/invalid/question/wontfix), looking at any 'help wanted' issues is a great place to start.

## Code of Conduct
This project has adopted the [Amazon Open Source Code of Conduct](https://aws.github.io/code-of-conduct).
For more information see the [Code of Conduct FAQ](https://aws.github.io/code-of-conduct-faq) or contact
opensource-codeofconduct@amazon.com with any additional questions or comments.

## Security issue notifications
If you discover a potential security issue in this project we ask that you notify AWS/Amazon Security via our [vulnerability reporting page](http://aws.amazon.com/security/vulnerability-reporting/). Please do **not** create a public github issue.

## Licensing

See the [LICENSE](LICENSE) file for our project's licensing. We will ask you to confirm the licensing of your contribution.
