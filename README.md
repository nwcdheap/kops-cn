# kops-cn
This project is aimed to help you easily deploy the latest kops clusterin AWS China regions such as NingXia or Beijing region. You will leverage the local mirors of docker images or assets that help you accelerate the cluster creation without suffering the huge latency and connectivity issues from within China to other public sites like `gcr.io`.

# Features
- [x] All docker images required for kops creation are mirrored in `Amazon ECR` **NingXia** or **Beijing** region.
- [x] All binary files or assets required for the cluster creation can be fetched directly from `Amazon S3` **Beijing** region.
- [x] Fast cluster creation and simple deployment
- [x] No VPN or secure tunnel required
