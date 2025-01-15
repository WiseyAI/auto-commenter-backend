import { ApifyClient } from 'apify-client';

// Types
interface FetchPostsParams {
    hashtags: string[];
    resultsLimit?: number;
    resultsType?: 'posts' | 'users';
}

interface FetchPostsResponse {
    success: boolean;
    items?: any[];
    count?: number;
    hashtags?: string[];
    error?: string;
    details?: string;
}

export class InstagramPostFetcher {
    private client: ApifyClient;

    constructor(apiToken: string) {
        this.client = new ApifyClient({
            token: apiToken,
        });
    }

    public async fetchPosts({
        hashtags,
        resultsLimit = 20,
        resultsType = 'posts'
    }: FetchPostsParams): Promise<FetchPostsResponse> {
        try {
            // Validate input
            if (!hashtags || !Array.isArray(hashtags) || hashtags.length === 0) {
                throw new Error('Invalid hashtags parameter');
            }

            // Prepare Actor input
            const input = {
                hashtags,
                resultsType,
                resultsLimit
            };

            // Run the Actor and wait for it to finish
            const run = await this.client.actor("reGe1ST3OBgYZSsZJ").call(input);

            // Fetch results from the run's dataset
            const { items } = await this.client.dataset(run.defaultDatasetId).listItems();

            return {
                success: true,
                items,
                count: items.length,
                hashtags
            };

        } catch (error: any) {
            console.error('Error in fetchPosts:', error);
            return {
                success: false,
                error: 'Failed to fetch hashtag data',
                details: error.message
            };
        }
    }

    public async checkActorStatus(): Promise<boolean> {
        try {
            const actor = await this.client.actor("reGe1ST3OBgYZSsZJ").get();
            return !!actor;
        } catch (error) {
            console.error('Error checking actor status:', error);
            return false;
        }
    }
}

// Export factory function for easier instantiation
export const createInstagramFetcher = (apiToken: string) => {
    return new InstagramPostFetcher(apiToken);
};

export default InstagramPostFetcher;
